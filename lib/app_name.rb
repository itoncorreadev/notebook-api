class AppName
  def Initialize(app)
    @app = app
  end

  def call(env)
    ['200', {'Content-Type' => 'text/html'}, ["#{Notebook API}"]]
  end
end
