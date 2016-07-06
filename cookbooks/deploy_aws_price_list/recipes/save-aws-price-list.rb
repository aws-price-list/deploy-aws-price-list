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

app_path = "/srv/save-aws-price-list"

package "git"

application app_path do

  git app_path do
    repository "https://github.com/aws-price-list/save-aws-price-list.git"
  end

  ruby '2'

  bundle_install

  ruby_execute "rake save_price_list[./spec/resources/]" do
    environment "DATABASE_URL" => "mongodb://127.0.0.1/aws-price-list"
  end

end
