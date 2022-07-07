#
#
#
#
#
class cas::config {
  assert_private()
  
  $merged_config = deep_merge($cas::config_default, $cas::config)
  $merged_config_logging = deep_merge($cas::loggingconfig_default, $cas::loggingconfig)

  file { extlib::path_join([$cas::config_dir, 'cas.properties']):
    ensure    => present,
    owner     => $cas::service_user,
    group     => $cas::service_group,
    mode      => '0770',
    content   => epp("${module_name}/cas.properties.epp", { 'config' => $merged_config}),
  }

  if $cas::logging_manage {
    file { extlib::path_join([$cas::config_dir, 'log4j2.xml']):
      ensure    => present,
      owner     => $cas::service_user,
      group     => $cas::service_group,
      mode      => '0770',
      content   => epp("${module_name}/log4j2.xml.epp", { 'config' => $merged_config_logging}),
    }
  }

}
