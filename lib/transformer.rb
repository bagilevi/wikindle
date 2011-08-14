
require 'erb'
class Transformer
  def initialize(content)
    @content = content
  end

  attr_accessor :content
  private :content=

  def execute
    cut_main_content
    remove_edit_links
    remove_section 'jumpto'
    insert_after "From Wikipedia, the free encyclopedia", ', <a href="/about">optimized for Kindle</a>'
    remove /-moz-column-count: \d+;/
    remove /-webkit-column-count: \d+;/
    remove /column-count: \d+;/
  end

  private

  def cut_main_content
    # Cut from original version
    cut_content = cut_string content,
                             '<!-- firstHeading -->',
                             '<!-- /bodyContent -->'
    self.content = cut_content unless cut_content.nil?

    # Cut from smartphone version
    cut_content = cut_string_inside content,
                             '<body>',
                             '</body>'
    self.content = cut_content unless cut_content.nil?
  end

  def cut_string_inside str, a, b
    i1 = str.index(a) or return
    i2 = str.index(b) or return
    str[(i1 + a.length) .. (i2 - 1)]
  end

  def cut_string str, a, b
    i1 = str.index(a) or return
    i2 = str.index(b) or return
    str[i1 .. (i2 + b.length - 1)]
  end

  def remove_edit_links
    content.gsub!(
      %r{<span class="editsection">.*>edit</a>\]</span>},
      ''
    )
  end

  def remove_section name
    content.gsub!(
      %r{<!-- #{name} -->.*<!-- /#{name} -->}m,
      ''
    )
  end

  def insert_after needle, insertee
    pos = content.index(needle) or return
    content.insert(pos + needle.length, insertee)
  end

  def remove regex
    content.gsub! regex, ''
  end
end
