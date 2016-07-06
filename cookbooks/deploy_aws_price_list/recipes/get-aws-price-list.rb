case node['platform']
  when 'centos'
    bash "yum groupinstall Development tools" do
      user "root"
      group "root"
      code <<-EOC
      yum groupinstall "Development tools" -y
      EOC
      not_if "yum grouplist installed | grep 'Development tools'"
    end
end

app_path = "/srv/get-aws-price-list"

package "git"

application app_path do

  git app_path do
    repository "https://github.com/aws-price-list/get-aws-price-list.git"
  end

  ruby '2'

  bundle_install

  rackup do
    port 8000
  end

end
