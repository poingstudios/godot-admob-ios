# update_pods.rb
$podfile_path = File.expand_path("../../../../../../Podfile", __FILE__)

def init_podfile_if_needed
  if File.exist?($podfile_path)
    puts "Podfile already exists."
  else
    puts "No Podfile found. Initializing..."
    system('cd ../../../../../ && pod init')
  end
end

def update_or_add_pod(pod_name, version)
  podfile_content = File.read($podfile_path)
  target_name = podfile_content.match(/target\s+'(.*?)'\s+do/)[1]
  formatted_pod = "pod '#{pod_name}', '#{version}'"

  if podfile_content.include?(pod_name)
    puts "Updating #{pod_name} to version #{version}"
    updated_podfile_content = podfile_content.gsub(/pod\s+'#{pod_name}'.*/, formatted_pod)
  else
    puts "Adding #{pod_name} (version #{version})"
    target_line = podfile_content.match(/target\s+'#{target_name}' do\n(.*?)\nend/m)[1]
    updated_target_line = "#{target_line}\n  #{formatted_pod}"
    updated_podfile_content = podfile_content.gsub(target_line, updated_target_line)
  end

  File.open($podfile_path, 'w') { |file| file.write(updated_podfile_content) }
end

pod_files_directory = '../libs'

init_podfile_if_needed

Dir.glob(File.join(pod_files_directory, '*-pods.txt')).each do |file_path|
  File.readlines(file_path).each do |line|
    pod_name, version = line.match(/pod '([^']+)',\s*'([^']+)'/).captures
    update_or_add_pod(pod_name, version)
  end
end
