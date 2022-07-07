class cas::service {
  assert_private()

  if $cas::service_manage {
    systemd::unit_file { "${cas::service_name}.service":
      content => epp("${module_name}/cas.service.conf.epp"),
      enable  => true,
      active  => true,
    }
  }
}
