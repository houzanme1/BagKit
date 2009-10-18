configuration do |c|
  c.project_name       = 'BagKit'
  c.main_ruby_file     = 'application'
  c.main_java_file     = 'org.rubyforge.rawr.Main'
  c.target_jvm_version = 1.5
  c.output_dir         = 'build'
  c.compile_ruby_files = true
  c.java_lib_dirs      = ['lib/java']
  c.files_to_copy      = [
    'bagit/README.txt',
    'bagit/LICENSE.txt',
    'bagit/conf/log4j.properties',
    'bagit/bin/bag',
    'bagit/bin/bag.bat',
    'bagit/bin/bag.classworlds.conf',
  ] + Dir.glob('bagit/lib/*.jar')
  c.source_exclude_filter = []
  c.source_dirs = [
    'src',
    'lib/ruby',
  ]
end
