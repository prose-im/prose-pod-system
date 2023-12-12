admins = {}

modules_enabled = {
  "roster";
  "saslauth";
  "tls";
  "dialback";
  "disco";
  "posix";
  "smacks";
  "private";
  "vcard_legacy";
  "vcard4";
  "version";
  "uptime";
  "time";
  "ping";
  "lastactivity";
  "pep";
  "blocklist";
  "limits";
  "carbons";
  "mam";
  "csi";
  "server_contact_info";
  "websocket";
}

allow_registration = false

reload_modules = { "tls" }

-- ssl = {
--   key = "/etc/prosody/certs/prose.org.local.key";
--   certificate = "/etc/prosody/certs/prose.org.local.crt";
-- }

c2s_require_encryption = true
s2s_require_encryption = true
s2s_secure_auth = false

c2s_stanza_size_limit = 256 * 1024
s2s_stanza_size_limit = 512 * 1024

consider_websocket_secure = true
cross_domain_websocket = true

limits = {
  c2s = {
    rate = "50kb/s";
    burst = "2s";
  };

  s2sin = {
    rate = "250kb/s";
    burst = "4s";
  };
}

contact_info = {
  admin = { "mailto:hostmaster@prose.org.local" };
}

archive_expires_after = "never"
default_archive_policy = true
max_archive_query_results = 100

upgrade_legacy_vcards = true

pidfile = "/var/run/prosody/prosody.pid"
authentication = "internal_hashed"

storage = "internal"

log = {
  info = "*console";
  warn = "*console";
  error = "*console";
}

interfaces = { "*" }

c2s_ports = { 5222 }
s2s_ports = { 5269 }

http_ports = { 5280 }
http_interfaces = { "*" }

https_ports = {}
https_interfaces = {}

VirtualHost "prose.org.local"

Component "groups.prose.org.local" "muc"
  name = "Chatrooms"
  restrict_room_creation = "local"
  modules_enabled = { "muc_mam" }
