class cas::install (



) {
  assert_private()
  
  $prereqs = ['openjdk-11-jdk-headless','git']
  ensure_packages($prereqs, {'ensure' => 'present'})

  group { $cas::service_group : } ->
  user { $cas::service_user :
    gid   => $cas::service_group,
  } ->
  exec { "cas_makepath ${cas::build_dir}" :
    creates     => $cas::build_dir,
    command     => "mkdir -p ${cas::build_dir}",
    path        => '/usr/bin',
  } ->
  file { $cas::build_dir:
    ensure   => directory,
    owner    => root,
    group    => $cas::service_group,
    mode     => '2755',
  }

  exec { "cas_makepath ${cas::config_dir}" :
    creates     => $cas::config_dir,
    command     => "mkdir -p ${cas::config_dir}",
    path        => '/usr/bin',
  } ->
  file { $cas::config_dir:
    ensure   => directory,
    owner    => root,
    group    => $cas::service_group,
    mode     => '2770',
  }

  exec { "cas_makepath ${cas::exe_dir}" :
    creates     => $cas::exe_dir,
    command     => "mkdir -p ${cas::exe_dir}",
    path        => '/usr/bin',
  } ->
  file { $cas::exe_dir :
    ensure    => directory,
    owner     => root,
    group     => $cas::service_group,
    mode      => '0750',
  }

  file { extlib::path_join([$cas::build_dir, 'getcas.sh']):
    ensure    => file,
    source    => "puppet:///modules/${module_name}/getcas.sh",
    owner     => root,
    group     => $cas::service_group,
    mode      => '0750',
  }
  $deps = $cas::modules_default + $cas::modules
  $module_string = join(unique($deps), ',')
  $executable_path = extlib::path_join([$cas::exe_dir, 'cas.war'])

  exec { 'cas_pull':
    command   => "/bin/bash ./getcas.sh --url ${cas::initializr_url} --type ${cas::project_type} --casVersion ${cas::cas_version} --modules ${module_string}",
    cwd       => $cas::build_dir,
    user      => root,
    unless    => "grep version=${cas::cas_version} overlay/gradle.properties",
    path      => '/usr/bin',
    require   => File["${cas::build_dir}"],
  } ->
  file_line { 'gradle executable':
    path => "${cas::build_dir}/overlay/gradle.properties",
    line => "executable=true",
    match => '^executable=',
  } ->
  exec { 'cas_build':
    command     => "${cas::build_dir}/overlay/gradlew clean build -DcasModules=${module_string}",
    cwd         => "${cas::build_dir}/overlay",
    user        => root,
    subscribe   => Exec['cas_pull'],
    refreshonly => true,
  } ->
  file { $executable_path:
    ensure     => present,
    owner      => $cas::service_user,
    group      => $cas::service_group,
    mode       => '0550',
    require    => File["${cas::exe_dir}"],
    subscribe  => Exec['cas_build'],
    source     => extlib::path_join([$cas::build_dir, 'overlay/build/libs/cas.war']),
  }
}
