-- Plugin Kong personnalisé pour l'authentification avancée
local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"

local CustomAuthHandler = BasePlugin:extend()

CustomAuthHandler.PRIORITY = 1000
CustomAuthHandler.VERSION = "1.0.0"

function CustomAuthHandler:new()
  CustomAuthHandler.super.new(self, "custom-auth")
end

function CustomAuthHandler:access(conf)
  CustomAuthHandler.super.access(self)

  local headers = ngx.req.get_headers()
  local client_ip = ngx.var.remote_addr

  -- Log de la requête pour audit
  ngx.log(ngx.INFO, "Custom Auth - IP: ", client_ip, " Path: ", ngx.var.request_uri)

  -- Vérification du User-Agent
  local user_agent = headers["User-Agent"] or ""
  if user_agent == "" then
    ngx.log(ngx.WARN, "Requête sans User-Agent depuis IP: ", client_ip)
  end

  -- Détection des bots simples
  local bot_patterns = {
    "bot", "crawler", "spider", "scraper", "python", "curl", "wget"
  }

  for _, pattern in ipairs(bot_patterns) do
    if string.find(string.lower(user_agent), pattern) then
      ngx.log(ngx.WARN, "Bot détecté: ", user_agent, " IP: ", client_ip)
      -- Vous pouvez décider de bloquer ou de rate-limit
      break
    end
  end

  -- Vérification des headers de sécurité
  if not headers["X-Requested-With"] and headers["Content-Type"] == "application/json" then
    ngx.log(ngx.INFO, "Requête JSON sans X-Requested-With")
  end
end

return CustomAuthHandler