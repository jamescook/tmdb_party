module TMDBParty
  class Person < Entity
    include Attributes
    lazy_callback :get_info!
    attributes :id, :popularity, :type => Integer
    attributes :score, :type => Float
    attributes :name, :url, :biography
    
    attributes :birthplace, :birthday
    
    def biography
      # HTTParty does not parse the encoded hexadecimal properly. It does not consider 000F to be a hex, but 000f is
      # A bug has been submitted about this
      read_attribute('biography').gsub("\\n", "\n").gsub(/\\u([0-9A-F]{4})/) { [$1.hex].pack("U") }
    end
    
    
    def get_info!
      person = tmdb.get_person(self.id)
      @attributes.merge!(person.attributes) if person
      @loaded = true
    end
  end
end
