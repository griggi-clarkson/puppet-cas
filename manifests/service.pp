class cas::service {
  assert_private()

  if $cas::service_manage {
    systemd::dropin_file { "${cas::service_name}.conf":
      unit    => "${cas::service_name}.service",
      content => epp("${module_name}/cas.service.conf.epp"),
    } ~> service { $cas::service_name:
      ensure  => running,
      enable  => true,
    }
  }
}
