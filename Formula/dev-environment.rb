class DevEnvironment < Formula
  desc "Configura ambiente de desenvolvimento instalando pacotes e scripts"
  homepage "https://github.com/salgueiroso/dev-environment"
  license "MIT"
  head "https://github.com/salgueiroso/dev-environment.git", branch: "main"
  
  # Como não há código fonte real, usamos um arquivo vazio ou dummy.
  # O SHA256 abaixo é de uma string vazia (padrão).
  url "file:///dev/null"
  version "1.0.0"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  # Dependências que o Homebrew vai instalar antes de tudo
  depends_on "nvm"
  depends_on "jenv"
  depends_on "rbenv"
  depends_on "leoafarias/fvm/fvm"

  # Adicione outros pacotes que seu script precise aqui...

  def install
    # 'tap.path' retorna o caminho absoluto para a raiz do Tap
    origem_script = tap.path/"configure_dev_environment.sh"

    # Verifica se o arquivo existe (boa prática)
    if origem_script.exist?
      # Copia do Tap para a pasta bin de instalação
      bin.install origem_script => "configure_dev_environment"
    else
      odie "Não foi possível encontrar o script no diretório do Tap!"
    end
  end

  # 2. Manipulação do ~/.zprofile
  # AVISO: O Homebrew bloqueia escrita automática na Home do usuário por segurança.
  # A forma "correta" é usar 'caveats' para pedir ao usuário que faça isso.
  def caveats
    <<~EOS
      ⚠️  Atenção:
      Para finalizar a configuração, execute o seguinte comando:

        #{opt_bin}/configure_dev_environment

      Isso garantirá que suas variáveis sejam carregadas.
    EOS
  end

  # 3. Testar se as dependências funcionam
  test do
    puts "Testando dependências..."
    
    # Testamos se o 'nvm' está acessível
    system "nvm", "--version"
    
    # Testamos se o 'jenv' está acessível
    system "jenv", "--version"
    
    # Testamos se o 'rbenv' está acessível
    system "rbenv", "--version"
    
    # Testamos se o 'fvm' está acessível
    system "fvm", "--version"
    
    # Validamos se o arquivo de configuração foi criado
    assert_predicate bin/"configure_dev_environment", :exist?
  end
end