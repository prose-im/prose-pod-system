-- Prose Pod Server
-- XMPP Server Configuration

-- Base server configuration
pidfile = "/var/run/prosody/prosody.pid"

authentication = "internal_hashed"
storage = "internal"

log = {
  info = "*console";
  warn = "*console";
  error = "*console";
}

-- Network interfaces/ports
interfaces = { "*" }

c2s_ports = { 5222 }
s2s_ports = { 5269 }

http_ports = { 5280 }
http_interfaces = { "*" }

https_ports = {}
https_interfaces = {}

-- Enabled modules
modules_enabled = {
  "roster";
  "groups";
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
  "s2s_bidi";
}

-- Path to SSL key and certificate for all server domains
ssl = {
  key = "/etc/prosody/certs/prose.org.local.key";
  certificate = "/etc/prosody/certs/prose.org.local.crt";
}

-- Disable in-band registrations (done through the Prose Pod Dashboard/API)
allow_registration = false

-- Mandate highest security levels
c2s_require_encryption = true
s2s_require_encryption = true
s2s_secure_auth = false

-- Enforce safety C2S/S2S limits
c2s_stanza_size_limit = 256 * 1024
s2s_stanza_size_limit = 512 * 1024

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

-- Allow reverse-proxying to WebSocket service over insecure local HTTP
consider_websocket_secure = true
cross_domain_websocket = true

-- Specify server administrator
contact_info = {
  admin = { "mailto:hostmaster@prose.org.local" };
}

-- MAM settings
archive_expires_after = "never"
default_archive_policy = true
max_archive_query_results = 100

-- Enable vCard legacy compatibility layer
upgrade_legacy_vcards = true

-- Define server members groups file
groups_file = "/etc/prosody/roster_groups.txt"

-- Server hosts and components
VirtualHost "prose.org.local"

Component "groups.prose.org.local" "muc"
  name = "Chatrooms"

  restrict_room_creation = "local"

  muc_log_all_rooms = true
  muc_log_by_default = true
  muc_log_expires_after = "never"
  max_archive_query_results = 100

  modules_enabled = { "muc_mam" }

Component "upload.prose.org.local" "http_file_share"
  name = "HTTP File Upload"

  http_file_share_size_limit = 20*1024*1024
  http_file_share_daily_quota = 250*1024*1024
  http_file_share_expires_after = -1
  http_host = "localhost"
  http_external_url = "http://localhost:5280/"
