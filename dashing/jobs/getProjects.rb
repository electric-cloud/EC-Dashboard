#projects = Hash.new({ value: 0 })

SCHEDULER.every '5s', :first_in => 0 do |job|
 http = Net::HTTP.new("localhost", "8000")
 req = Net::HTTP::Get.new("/rest/v1.0/projects")
 req.basic_auth "admin", "changeme"
 response = http.request(req)
 projectName = JSON.parse(response.body)["project"][0]["projectName"]
 
 #projects[projectName] = { label: projectName, value: 123 }
 
 #send_event('projects', { items: projects.values })
 send_event('projects', text: projectName)
end
