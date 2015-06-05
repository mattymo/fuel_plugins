notice("MODULAR: deploy_hiera_override.pp")

$gamma_plugin = hiera('gamma-lcp-ui')

###################
if hiera('role', 'none') == 'primary-gamma-lcp-dbng' {
  $primary_database = 'true'
} else {
  $primary_database = 'false'
}

if hiera('role', 'none') =~ /^primary/ {
  $primary_controller = 'true'
} else {
  $primary_controller = 'false'
}

case hiera('role', 'none') {
  /lcp-dbng/: {
    $corosync_roles = ['primary-gamma-lcp-dbng', 'gamma-lcp-dbng']
  }
  /lcp-nova/: {
    $corosync_roles = ['primary-gamma-lcp-nova', 'gamma-lcp-nova']
  }
  default: {
     $corosync_roles = ['primary-controller', 'controller']
  }
} 

###################
$calculated_content = inline_template('
primary_database: <%= @primary_database %>
primary_controller: <%= @primary_controller %>
corosync_roles:
<%
@corosync_roles.each do |crole|
  %>  - <%= crole %>
<% end -%>
')

###################
file {'/etc/hiera/override':
  ensure  => directory,
} ->
file { '/etc/hiera/override/common.yaml':
  ensure  => file,
  content => "${gamma_plugin['yaml_additional_config']}\n${calculated_content}\n",
}

