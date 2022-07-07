# command for getting modules with current env: getcas --modules jetty,duo,ldap,hz,bootadmin,core-monitor,support-hazelcast-monitor,support-ldap-monitor,support-metrics,core-monitor,support-saml,support-saml-idp,support-git-service-registry
# command for building: ./gradlew clean build -DcasModules=jetty,duo,ldap,hz,bootadmin,core-monitor,support-hazelcast-monitor,support-ldap-monitor,support-metrics,support-saml,support-saml-idp 
# @summary Installs and manages the Apereo CAS service.
#
# @example Default installation of 6.5.2 with managed config
#   include cas
# @param build_dir
#   Directory for the build process
# @param exe_dir
#   Directory to move the built CAS executable to
# @param config_dir
#   Directory to house the CAS config and other files
# @param initializr_url
#   URL pointing at instance of CAS Initializr for build
# @param cas_version
#   Version of CAS to install
# @param project_type
#   Type of CAS project to build
# @param modules
#   Dependencies to include in the CAS build
# @param service_manage
#   Whether or not to manage the CAS service
# @param service_name
#   Name for CAS service
# @param service_user
#   Username for CAS service
# @param service_group
#   Group for CAS service
# @param [Hash] config
#   Config parameters
#
class cas (
  Stdlib::Absolutepath $build_dir = '/opt/cas/tmp',
  Stdlib::Absolutepath $exe_dir = '/opt/cas/bin',
  Stdlib::Absolutepath $config_dir = '/opt/cas/config',
  Stdlib::HTTPUrl $initializr_url = 'https://casinit.herokuapp.com/starter.tgz',
  String[1] $cas_version = '6.5.2',
  String[1] $project_type = 'cas-overlay',
  Array[String[1]] $modules_default = ['core'],
  Array[String[1]] $modules = [],
  Boolean $logging_manage = false,
  Boolean $service_manage = true,
  String[1] $service_name = 'cas',
  String[1] $service_user = 'cas',
  String[1] $service_group = 'cas',
  Optional[Hash] $config = {},
  Hash $config_default = { 
    'logging.config' => extlib::path_join([$cas::config_dir,'log4j2.xml']),
    'cas.standalone.configuration-directory' => $cas::config_dir,
     },
  Optional[Hash] $loggingconfig = {},
  Optional[Hash] $loggingconfig_default = {},
 ) {

  contain cas::install
  contain cas::config
  contain cas::service
}
