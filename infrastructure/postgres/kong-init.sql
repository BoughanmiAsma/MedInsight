-- Initialisation sécurisée de la base Kong
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Table pour les audits Kong custom
CREATE TABLE IF NOT EXISTS kong_security_audit (
                                                   id SERIAL PRIMARY KEY,
                                                   service_name VARCHAR(255),
    route_path VARCHAR(500),
    client_ip INET,
    user_agent TEXT,
    request_method VARCHAR(10),
    response_status INTEGER,
    request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    api_key_used VARCHAR(255),
    blocked BOOLEAN DEFAULT false,
    block_reason TEXT
    );

-- Index pour performances
CREATE INDEX IF NOT EXISTS idx_kong_audit_service ON kong_security_audit(service_name);
CREATE INDEX IF NOT EXISTS idx_kong_audit_time ON kong_security_audit(request_time);
CREATE INDEX IF NOT EXISTS idx_kong_audit_status ON kong_security_audit(response_status);

-- Vue pour rapports sécurité Kong
CREATE OR REPLACE VIEW kong_security_reports AS
SELECT
    service_name,
    COUNT(*) as total_requests,
    COUNT(CASE WHEN response_status >= 400 THEN 1 END) as error_requests,
    COUNT(CASE WHEN blocked = true THEN 1 END) as blocked_requests,
    COUNT(DISTINCT client_ip) as unique_clients,
    MIN(request_time) as first_request,
    MAX(request_time) as last_request
FROM kong_security_audit
GROUP BY service_name;

-- Fonction pour nettoyer les vieux logs Kong
CREATE OR REPLACE FUNCTION cleanup_old_kong_logs()
RETURNS void AS $$
BEGIN
DELETE FROM kong_security_audit
WHERE request_time < CURRENT_TIMESTAMP - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;

-- Planning de nettoyage automatique (si pg_cron disponible)
-- SELECT cron.schedule('0 2 * * *', 'SELECT cleanup_old_kong_logs()');

COMMENT ON TABLE kong_security_audit IS 'Table d audit sécurité pour Kong API Gateway';
COMMENT ON VIEW kong_security_reports IS 'Rapports de sécurité pour monitoring API Gateway';