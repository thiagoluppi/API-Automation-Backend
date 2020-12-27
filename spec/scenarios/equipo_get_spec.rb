describe "GET /equipos/{equipos_id}" do
  before(:all) do
    payload = { email: "thiago@icloud.com",
                password: "pwd123" }

    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "obter unico equipo" do
    before(:all) do
      # Dado que eu tenho um novo equipamento
      @payload = { thumbnail: Helpers::get_thumb("sanfona.jpg"),
                   name: "Sanfona cara",
                   category: "Outros",
                   price: 699 }

      MongoDB.new.remove_equipo(@payload[:name], @user_id)

      # E eu tenho o ID desse equipamento
      equipo = Equipos.new.create(@payload, @user_id)
      @equipo_id = equipo.parsed_response["_id"]

      # Quando faco uma requisicao GET por ID
      @result = Equipos.new.find_by_id(@equipo_id, @user_id)
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end

    it "deve retornar o nome" do
      expect(@result.parsed_response).to include("name" => @payload[:name])
    end
  end

  context "equipo nao existe" do
    before(:all) do
      @result = Equipos.new.find_by_id(MongoDB.new.get_mongo_id, @user_id)
    end

    it "deve retornar 404" do
      expect(@result.code).to eql 404
    end
  end
end

describe "GET /equipos" do
  before(:all) do
    payload = { email: "penelope@gmail.com",
                password: "pwd123" }

    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "obter uma lista" do
    before(:all) do
      # Dado que eu tenho uma lista de equipos
      payloads = [{ thumbnail: Helpers::get_thumb("sanfona.jpg"),
                    name: "Sanfona cara",
                    category: "Outros",
                    price: 699 },
                  { thumbnail: Helpers::get_thumb("trompete.jpg"),
                    name: "Trompete",
                    category: "Outros",
                    price: 399 },
                  { thumbnail: Helpers::get_thumb("slash.jpg"),
                    name: "Les Paul do Slash",
                    category: "Outros",
                    price: 999 }]

      payloads.each do |payload|
        MongoDB.new.remove_equipo(payload[:name], @user_id)
        Equipos.new.create(payload, @user_id)
      end

      #Quando faco uma requisicao GET para /equipos
      @result = Equipos.new.list(@user_id)
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end

    it "deve retornar uma lista de equipos" do
      puts @result.parsed_response
      puts @result.parsed_response.class
    end
  end
end
