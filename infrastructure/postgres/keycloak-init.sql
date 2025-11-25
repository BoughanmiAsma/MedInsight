-- Initialisation sécurisée de la base Keycloak
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Audit des connexions
CREATE TABLE IF NOT EXISTS keycloak_audit_connections (
                                                          id SERIAL PRIMARY KEY,
                                                          username VARCHAR(255),
    connection_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent TEXT,
    success BOOLEAN
    );

-- Index pour les performances
CREATE INDEX IF NOT EXISTS idx_audit_connections_username ON keycloak_audit_connections(username);
CREATE INDEX IF NOT EXISTS idx_audit_connections_time ON keycloak_audit_connections(connection_time);

-- Vue pour les rapports de sécurité
CREATE OR REPLACE VIEW keycloak_security_reports AS
SELECT
    username,
    COUNT(*) as total_attempts,
    COUNT(CASE WHEN success = true THEN 1 END) as successful_logins,
    COUNT(CASE WHEN success = false THEN 1 END) as failed_attempts,
    MIN(connection_time) as first_attempt,
    MAX(connection_time) as last_attempt
FROM keycloak_audit_connections
GROUP BY username;

-- Fonction pour nettoyer les vieux logs
CREATE OR REPLACE FUNCTION cleanup_old_audit_logs()
RETURNS void AS $$
BEGIN
DELETE FROM keycloak_audit_connections
WHERE connection_time < CURRENT_TIMESTAMP - INTERVAL '90 days';
END;
$$ LANGUAGE plpgsql;

-- Commentaires pour la documentation
COMMENT ON TABLE keycloak_audit_connections IS 'Table d audit des connexions Keycloak pour conformité sécurité';
COMMENT ON VIEW keycloak_security_reports IS 'Rapports de sécurité pour monitoring des connexions';