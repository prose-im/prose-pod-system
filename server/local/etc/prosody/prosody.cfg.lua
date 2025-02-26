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

-- Modules
modules_enabled = {
  "auto_activate_hosts";
  "register";
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
  "csi";
  "server_contact_info";
  "websocket";
  "s2s_bidi";
  "mam";
}

-- Path to SSL key and certificate for all server domains
ssl = {
  certificate = "/etc/prosody/certs/prose.org.local.crt";
  key = "/etc/prosody/certs/prose.org.local.key";
}

-- Path to external plugins
plugin_paths = { "/usr/local/lib/prosody/modules" }

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

VirtualHost "admin.prose.org.local"
  admins = { "prose-pod-api@admin.prose.org.local" }

  -- Modules
  modules_enabled = {
    "admin_rest";
    "init_admin";
  }

  -- HTTP settings
  http_host = "prose-pod-server"
  http_external_url = "http://prose-pod-server:5280"

  -- mod_init_admin
  init_admin_jid = "prose-pod-api@admin.prose.org.local"
  init_admin_password_env_var_name = "PROSE_BOOTSTRAP__PROSE_POD_API_XMPP_PASSWORD"

Component "groups.prose.org.local" "muc"
  name = "Chatrooms"

  -- Modules
  modules_enabled = {
    "muc_mam";
    "muc_public_affiliations";
  }

  -- MAM settings
  max_archive_query_results = 100

  restrict_room_creation = "local"

  -- MUC settings
  muc_log_all_rooms = true
  muc_log_by_default = true
  muc_log_expires_after = "never"

Component "upload.prose.org.local" "http_file_share"
  name = "HTTP File Upload"

  -- HTTP settings
  http_file_share_size_limit = 20 * 1024 * 1024
  http_file_share_daily_quota = 250 * 1024 * 1024
  http_file_share_expires_after = -1
  http_host = "localhost"
  http_external_url = "http://localhost:5280"
