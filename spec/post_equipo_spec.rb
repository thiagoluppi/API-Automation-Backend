describe "POST /equipos" do
  before(:all) do
    payload = { email: "thiago@icloud.com",
                password: "pwd123" }

    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "novo equipo" do
    before(:all) do
      thumbnail = File.open(File.join(Dir.pwd, "/spec/fixtures/images", "kramer.jpg"), "rb")

      payload = { thumbnail: thumbnail,
                  name: "Kramer Eddie Van Halen",
                  category: "Cordas",
                  price: 699 }

      # MongoDB.new.remove_equipo("luppi", payload[:email])

      @result = Equipos.new.create(payload, @user_id)
      puts @result
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end
  end
end
