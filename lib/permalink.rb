class String
  # From Typo:
  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process  
  def to_url
    result = self.downcase

    # replace quotes by nothing
    result.gsub!(/['"]/, '')

    # strip all non word chars
    result.gsub!(/\W/, ' ')

    # replace all white space sections with a dash
    result.gsub!(/\ +/, '-')

    # trim dashes
    result.gsub!(/(-)$/, '')
    result.gsub!(/^(-)/, '')

    result
  end
end

class ActiveRecord::Base

  def self.use_permalink( attr )
    self.class_eval <<-EOF, __FILE__, __LINE__
      before_save { |r| r.permalink = r.#{attr}.to_url }
      
      def to_param
        self.permalink
      end
    EOF
  end
end
