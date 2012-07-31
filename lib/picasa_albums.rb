require "picasa_albums/web_albums"
require "picasa_albums/config"
require "picasa_albums/version"

module PicasaAlbums
  def self.albums(options = {})
    web_albums = PicasaAlbums::WebAlbums.new(options.delete(:google_user))
    web_albums.albums(options)
  end

  def self.photos(options = {})
    raise ArgumentError.new("You must specify album_id") unless options[:album_id]
    web_albums = PicasaAlbums::WebAlbums.new(options.delete(:google_user))
    web_albums.photos(options.delete(:album_id), options)
  end
end