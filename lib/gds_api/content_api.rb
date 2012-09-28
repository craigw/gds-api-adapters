require_relative 'base'
require_relative 'exceptions'

class GdsApi::ContentApi < GdsApi::Base
  include GdsApi::ExceptionHandling

  def sections
    get_json!("#{base_url}/tags.json?type=section")
  end

  def tag(tag)
    get_json("#{base_url}/tags/#{CGI.escape(tag)}.json")
  end

  def with_tag(tag)
    get_json!("#{base_url}/with_tag.json?tag=#{CGI.escape(tag)}&include_children=1")
  end

  def curated_list(tag)
    get_json("#{base_url}/with_tag.json?tag=#{CGI.escape(tag)}&sort=curated")
  end

  def artefact(slug, edition=nil)
    url = "#{base_url}/#{slug}.json"
    if edition
      if options.include?(:bearer_token)
        url += "?edition=#{edition}"
      else
        raise GdsApi::NoBearerToken
      end
    end
    get_json(url)
  end

  def artefact_with_snac_code(slug, snac)
    get_json("#{base_url}/#{slug}.json?snac=#{CGI.escape(snac)}")
  end

  def local_authority(snac_code)
    get_json("#{base_url}/local_authorities/#{CGI.escape(snac_code)}.json")
  end

  def local_authorities_by_name(name)
    get_json!("#{base_url}/local_authorities.json?name=#{CGI.escape(name)}")
  end

  def local_authorities_by_snac_code(snac_code)
    get_json!("#{base_url}/local_authorities.json?snac_code=#{CGI.escape(snac_code)}")
  end

  def business_support_schemes(identifiers)
    identifiers_string = identifiers.map {|i| CGI.escape(i)}.join(',')
    get_json!("#{base_url}/business_support_schemes.json?identifiers=#{identifiers_string}")
  end

  private
    def base_url
      endpoint
    end
end
