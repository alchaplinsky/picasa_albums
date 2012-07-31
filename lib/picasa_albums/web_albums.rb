require "net/http"
require "xmlsimple"

module PicasaAlbums
  class WebAlbums
    def initialize(user)
      PicasaAlbums.config.google_user = user if user
      raise ArgumentError.new("You must specify google_user") unless PicasaAlbums.config.google_user
    end

    def albums(options = {})
      data = connect("/data/feed/api/user/#{PicasaAlbums.config.google_user}", options)
      xml = XmlSimple.xml_in(data)
      albums = []
      xml["entry"].each do |album|
        attributes = {}
        attributes[:id] = album["id"][1]
        attributes[:title] = album["title"][0]["content"]
        attributes[:summary] = album["summary"][0]["content"]
        attributes[:photos_count] = album["numphotos"][0].to_i
        attributes[:photo] = album["group"][0]["content"]["url"]
        attributes[:thumbnail] = album["group"][0]["thumbnail"][0]["url"]
        attributes[:slideshow] = album["link"][1]["href"] + "#slideshow"
        attributes[:updated] = album["updated"][0]
        attributes[:url] = album["link"][1]["href"]
        albums << attributes
      end if xml["entry"]
      albums
    end

    def photos(album_id, options = {})
      data = connect("/data/feed/api/user/#{PicasaAlbums.config.google_user}/albumid/#{album_id}", options)
      xml = XmlSimple.xml_in(data)
      album_title = xml["title"][0]["content"] 
      album_link = xml["link"][0]["href"]
      photos = []
      xml["entry"].each do |photo|
        attributes = {}
        attributes[:id] = photo["id"][1]
        attributes[:title] = photo["group"][0]["description"][0]["content"]
        attributes[:thumbnail_1] = photo["group"][0]["thumbnail"][0]["url"]
        attributes[:thumbnail_2] = photo["group"][0]["thumbnail"][1]["url"]
        attributes[:thumbnail_3] = photo["group"][0]["thumbnail"][2]["url"]
        attributes[:photo] = photo["content"]["src"]
        photos << attributes
      end if xml["entry"]
      {:album_title => album_title, :album_link => album_link, :photos => photos, :slideshow => xml["link"][1]["href"] + "#slideshow"}
    end

    private

    def connect(url, options = {})
      full_url = "http://picasaweb.google.com" + url
      full_url += "?" + encode_options(options) unless options.empty?
      Net::HTTP.get(URI.parse(full_url))
    end
    
    def encode_options(options)
      options.map{|key, val| "#{key}=#{val}"}.join("&")
    end
  end
end
