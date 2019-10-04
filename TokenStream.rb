class TokenStream

  def initialize (source)
    @source = source
    @buffer = []
    fill
    @pos = 0
  end

  def fill ()
    more = fetch
    while more == true
      more = fetch
    end
  end

  def fetch ()
    token = @source.getToken
    @buffer.push(token)

    if token.kind != 'EOF'
      true
    else
      false
    end
  end

  def consume ()
    @pos += 1
  end

  def index ()
    # Does this ever get used?
    @pos
  end

  def lookahead ()
    @buffer[@pos]
  end

  def get (i)
    @buffer[i]
  end

  def buffer ()
    # does anything ever need to get the buffer directly?
    @buffer
  end

end
