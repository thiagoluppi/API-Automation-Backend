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
end
