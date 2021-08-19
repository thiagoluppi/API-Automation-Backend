require_relative "routes/sessions"
require_relative "routes/signup"
require_relative "routes/equipos"

require_relative "libs/mongo"
require_relative "helpers"

require "digest/md5"

# Método que converte o password em MD5 aceito pelo banco MongoDB
def to_md5(pass)
  return Digest::MD5.hexdigest(pass)
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Massa de usuários criados para rodar o regressivo da API sem precisar ficar criando na mão quando o ambiente for refeito
  config.before(:suite) do
    users = [
      { name: "Thiago Messias Luppi", email: "thiago.luppi@icloud.com", password: self.to_md5("pwd123") },
      { name: "Ed", email: "ed@gmail.com", password: self.to_md5("pwd123") },
      { name: "Joe", email: "joe@gmail.com", password: self.to_md5("pwd123") }
    ]

    # Limpa todo o banco de users, depois o recria usando as sementes acima " users = [ ..."
    MongoDB.new.drop_danger
    MongoDB.new.insert_users(users)
  end
end
