namespace :flex do
  task :build do
    bin_files = compc("bin", "flexspec")
    puts "Built #{bin_files}"
    
    bin_files
  end

  def mxmlc(dest_dir, file_name, app_dir)
    puts
    puts "Compiling Flex Application '#{file_name}'..."
    puts
  
    current_dir = Dir.pwd
    swf_file = File.join(dest_dir, File.basename(file_name).ext('swf'))
    args = "-load-config #{current_dir}/build/flex-config.xml +applib=#{current_dir} +MPFlexLib=#{flexlib_path} #{app_dir}/#{file_name}.mxml -output #{swf_file}"

    run_command("mxmlc", args)

    swf_file
  end

  def compc(dest_dir, file_name)
     # compc -load-config build/flex-config.xml +applib="$(pwd)" -include-sources src -output bin/flexlib.swc
     puts
     puts "Compiling Flex Library Application '#{file_name}'..."
     puts
   
     current_dir = Dir.pwd
     swc_file = File.join(dest_dir, File.basename(file_name).ext('swc'))
     args = "-load-config #{current_dir}/build/flex-config.xml +applib=#{current_dir} -output #{swc_file}"

     run_command("compc", args)

     swc_file
  end

  def amxmlc(dest_dir, file_name)
    # mxmlc -load-config build/flex-config.xml -compiler.source-path src -compiler.include-libraries ~/MoneyPools/flexlib/bin -- src/OfxClient.mxml
    puts
    puts "Compiling AIR Application '#{file_name}'..."
    puts
  
    swf_file = File.join(dest_dir, File.basename(file_name).ext('swf'))
    args = "-load-config #{current_dir}/build/flex-config.xml +applib=. +MPFlexLib=#{flexlib_path} src/#{file_name}.mxml -output #{swf_file}"

    command = RUBY_PLATFORM =~ /win32/ ? "mxmlc" : "amxmlc"

    run_command(command, args)
  
    swf_file
  end

  def adt(dest_dir, file_name, out_name,  certificate_info={}, src_dir="src", bin_dir="bin")
    # adt -package -storetype pkcs12 -keystore build/self-signed-cert.p12 -storepass password uploader.air src/OfxClient-app.xml bin/OfxClient.swf -C src/ assets
    puts
    puts "Signing and Building Release Version of '#{file_name}'..."
    puts
  
    air_file = File.join(dest_dir, File.basename(out_name).ext('air'))

    command_parts = []
    command_parts << "-package"
    certificate_info.each_pair do |option, value|
      command_parts << "-#{option} #{value}"
    end
  
    command_parts << air_file
    command_parts << "#{src_dir}/#{file_name}-app.xml"
    command_parts << "#{bin_dir}/#{file_name}.swf"
    command_parts << "-C #{src_dir}/ assets"
  
    args = command_parts.join(' ')
    run_command("adt", args)

    air_file
  end

  def run_command(command, args)
    command = "cmd.exe /C #{command}" if RUBY_PLATFORM =~ /win32/
    full_command = [command, args].join(' ')

    puts "Running command: #{full_command}"

    if system(full_command) === true
      puts '-- Compile completed --'
    else
      puts "-- The command returned: #{$?}" # Displays error message
      fail '-- Compile failed -- '
    end
  end
end