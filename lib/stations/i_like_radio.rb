require "pp"

module Station
  data = File.read(File.join(File.dirname(__FILE__), "../lists/ilikeradio.json"))
  JSON.parse(data).each do |station|
    Class.new(Format::JSON) do
      config do
        id station.fetch("name").parameterize
        url "http://unison.mtgradio.se/api/v1/channel?with=currentsong&type[]=live&type[]=playlist"
        args [station.fetch("id")]
      end

      def process(id)
        raw   = data.select{ |ss| ss.fetch("id") == id }.first
        track  = raw && raw.fetch("currentsong").fetch("song")
        artist = track && track.fetch("artist_name")
        song   = track && track.fetch("title")
        { artist: artist, song: song }
      end
    end
  end
end