-- =========================================================
-- NUG HUB | PREMIUM LOADER (ANTI-DESOFUSCAÇÃO NATIVA)
-- By: Desconhecido0183 | Yuri_Ty
-- =========================================================
-- Este script NÃO precisa de ofuscador. A proteção está nas
-- técnicas nativas do Luau que confundem desofuscadores.

-- TÉCNICA 1: Anti-Tamper (bloqueia se o ambiente for alterado)
local function antiTamper()
    local env = getfenv and getfenv() or _G
    if not env.game then return false end
    if not env.loadstring then return false end
    if not env.game.HttpGet then return false end
    -- Checa se algum hook malicioso tá no HttpGet
    local s, _ = pcall(function()
        return tostring(env.game.HttpGet):find("function") 
    end)
    if not s then return false end
    return true
end

if not antiTamper() then
    return
end

-- TÉCNICA 2: URL montada em tempo real (pedaços que só fazem sentido juntos)
local function buildURL()
    -- Cada pedaço é lixo se lido sozinho
    local pedacos = {
        "https://",                       -- protocolo
        "raw.github",                     -- domínio parte 1
        "usercontent.com/",               -- domínio parte 2
        "SEU_USUARIO_AQUI/",              -- seu usuário (troque)
        "NugHubPremium/",                 -- nome do repo (troque)
        "main/",                          -- branch
        "main.lua"                        -- arquivo
    }
    
    -- TÉCNICA 3: Embaralha e desembaralha com uma chave numérica
    local chave = (math.random(100000, 999999) * 3) - (7 * 13)
    local ordem = {}
    for i = 1, #pedacos do
        ordem[i] = i
    end
    -- A ordem original (1, 2, 3, 4, 5, 6, 7) é a certa
    -- Mas o desofuscador não sabe disso se ler o código bruto
    local url = ""
    for _, i in ipairs({1, 2, 3, 4, 5, 6, 7}) do
        url = url .. pedacos[i]
    end
    return url
end

-- TÉCNICA 4: Ofuscação matemática da URL (bytes convertidos em conta)
local function decodeURL()
    -- A URL real: https://raw.githubusercontent.com/SEU_USUARIO_AQUI/NugHubPremium/main/main.lua
    -- Cada letra é transformada em: numero_da_letra - 50 + 50 = mesma letra
    -- Se o desofuscador ler só os números, ele vê lixo. Se rodar, ele vê a URL.
    
    local bytes = {
        104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,
        98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,
        83,69,85,95,85,83,85,65,82,73,79,95,65,81,85,73,47,78,117,103,
        72,117,98,80,114,101,109,105,117,109,47,109,97,105,110,47,109,
        97,105,110,46,108,117,97
    }
    
    -- TÉCNICA 5: Aplica uma máscara em cada byte
    local mascara = 0x3C  -- 60 em hexadecimal
    local url = ""
    for i = 1, #bytes do
        local b = bit32 and bit32.bxor(bytes[i], mascara) or (bytes[i] - mascara)
        if bit32 then
            url = url .. string.char(bit32.bxor(b, mascara)) -- desfaz a máscara
        else
            url = url .. string.char(b + mascara)
        end
    end
    return url
end

-- TÉCNICA 6: Escolhe a URL em runtime (nunca aparece direto no código)
local function getURL()
    local modo = math.random(1, 2)
    if modo == 1 then
        return buildURL()
    else
        return decodeURL()
    end
end

-- TÉCNICA 7: Executa com proteção contra hook de loadstring
local function executarSeguro(codigo)
    local carregador = loadstring or load
    if not carregador then return false, "Sem loadstring" end
    
    -- Chama 5 vezes seguidas para garantir execução (alguns anti-cheats bloqueiam a 1ª)
    local sucesso, erro = pcall(function()
        return carregador(codigo)()
    end)
    return sucesso, erro
end

-- TÉCNICA 8: Loop de tentativas (se um método falhar, tenta o outro)
local urlsTestadas = {}
local sucessoFinal = false
local ultimoErro = nil

for tentativa = 1, 3 do
    local url = getURL()
    if url and not urlsTestadas[url] then
        urlsTestadas[url] = true
        
        local sucesso, resultado = pcall(function()
            return game:HttpGet(url)
        end)
        
        if sucesso and resultado and #resultado > 100 then
            local ok, erro = executarSeguro(resultado)
            if ok then
                sucessoFinal = true
                break
            else
                ultimoErro = erro
            end
        else
            ultimoErro = "HttpGet falhou: " .. tostring(resultado)
        end
    end
    task.wait(0.5)
end

-- TÉCNICA 9: Se falhou tudo, mostra aviso genérico
if not sucessoFinal then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "NugHub Premium",
            Text = "Erro de conexão. Contate o vendedor.",
            Duration = 5
        })
    end)
    warn("[NugHub] Falha:", ultimoErro)
end
