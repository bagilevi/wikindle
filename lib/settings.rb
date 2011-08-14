class Settings
  SIZE_OPTIONS = [16, 18, 20, 24, 28, 32]

  def initialize controller
    @controller = controller
  end

  attr_reader :controller

  def cookies
    controller.request.cookies
  end

  def size
    (cookies["size"] || 20).to_i
  end

  def smaller_size
    (size * 0.85).round
  end

  def self.save(controller)
    new(controller).save
  end

  def save_from_input
    controller.response.set_cookie("size",
                                   :value => controller.params["size"],
                                   :expires => Time.now + 10 * 365 * 24 * 3600)
  end
end


