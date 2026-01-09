-- Vault encryption patch for pgsodium 3.1.9
-- Uses raw key encryption (no server key required)
-- This bypasses the pgsodium server key requirement by using per-secret keys

-- Simplified create_secret using raw key bytes (positional arguments)
CREATE OR REPLACE FUNCTION vault.create_secret(
  new_secret text,
  new_name text DEFAULT NULL,
  new_description text DEFAULT '',
  new_key_id uuid DEFAULT NULL
) RETURNS uuid AS $$
DECLARE
  secret_id uuid;
  secret_nonce bytea;
  encrypted_secret text;
  raw_key bytea;
BEGIN
  -- Generate new UUID and nonce
  secret_id := gen_random_uuid();
  secret_nonce := pgsodium.crypto_aead_det_noncegen();

  -- Generate a raw key for encryption
  raw_key := pgsodium.crypto_aead_det_keygen();

  -- Encrypt the secret using raw key (positional: message, additional, key, nonce)
  encrypted_secret := encode(
    pgsodium.crypto_aead_det_encrypt(
      convert_to(new_secret, 'utf8'),
      convert_to(secret_id::text, 'utf8'),
      raw_key,
      secret_nonce
    ),
    'base64'
  );

  -- Store encrypted secret with key metadata in description field
  -- Format: "actual_description::key::base64_encoded_key"
  INSERT INTO vault.secrets (id, secret, name, description, key_id, nonce, created_at, updated_at)
  VALUES (
    secret_id,
    encrypted_secret,
    new_name,
    COALESCE(new_description, '') || '::key::' || encode(raw_key, 'base64'),
    new_key_id,
    secret_nonce,
    now(),
    now()
  );

  RETURN secret_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Decrypted secrets view (positional arguments)
CREATE OR REPLACE VIEW vault.decrypted_secrets AS
SELECT
  s.id,
  s.name,
  CASE
    WHEN s.description LIKE '%::key::%' THEN split_part(s.description, '::key::', 1)
    ELSE s.description
  END as description,
  s.secret,
  CASE
    WHEN s.description LIKE '%::key::%' THEN
      convert_from(
        pgsodium.crypto_aead_det_decrypt(
          decode(s.secret, 'base64'),
          convert_to(s.id::text, 'utf8'),
          decode(split_part(s.description, '::key::', 2), 'base64'),
          s.nonce
        ),
        'utf8'
      )
    ELSE NULL
  END as decrypted_secret,
  s.key_id,
  s.nonce,
  s.created_at,
  s.updated_at
FROM vault.secrets s;

-- Update secret function (positional arguments)
CREATE OR REPLACE FUNCTION vault.update_secret(
  secret_id uuid,
  new_secret text DEFAULT NULL,
  new_name text DEFAULT NULL,
  new_description text DEFAULT NULL,
  new_key_id uuid DEFAULT NULL
) RETURNS void AS $$
DECLARE
  current_desc text;
  key_part text;
  raw_key bytea;
  secret_nonce bytea;
  encrypted_secret text;
BEGIN
  -- Get current key from description
  SELECT description INTO current_desc FROM vault.secrets WHERE id = secret_id;

  IF current_desc LIKE '%::key::%' THEN
    key_part := split_part(current_desc, '::key::', 2);
  ELSE
    key_part := '';
  END IF;

  IF new_secret IS NOT NULL AND key_part != '' THEN
    raw_key := decode(key_part, 'base64');
    secret_nonce := pgsodium.crypto_aead_det_noncegen();

    -- Encrypt with positional arguments: message, additional, key, nonce
    encrypted_secret := encode(
      pgsodium.crypto_aead_det_encrypt(
        convert_to(new_secret, 'utf8'),
        convert_to(secret_id::text, 'utf8'),
        raw_key,
        secret_nonce
      ),
      'base64'
    );

    UPDATE vault.secrets SET
      secret = encrypted_secret,
      nonce = secret_nonce,
      name = COALESCE(new_name, name),
      description = COALESCE(new_description, split_part(description, '::key::', 1)) || '::key::' || key_part,
      updated_at = now()
    WHERE id = secret_id;
  ELSE
    UPDATE vault.secrets SET
      name = COALESCE(new_name, name),
      description = CASE
        WHEN new_description IS NOT NULL AND key_part != '' THEN new_description || '::key::' || key_part
        WHEN new_description IS NOT NULL THEN new_description
        ELSE description
      END,
      updated_at = now()
    WHERE id = secret_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
