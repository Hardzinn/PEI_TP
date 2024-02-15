module namespace page = 'http://basex.org/examples/web-page';

declare namespace i="http://www.TPPEI2024.pt/TipoVendas";
declare namespace j="http://www.TPPEI2024.pt/ResumoVendas";
declare namespace k="http://www.TPPEI2024.pt/InformacoesGerais";
declare namespace l="http://www.TPPEI2024.pt/Produtos";
declare namespace q="http://www.TPPEI2024.pt/Clientes";
declare namespace p="http://www.TPPEI2024.pt/TipoDevolucoes";
declare namespace o="http://www.TPPEI2024.pt/ResumoDevulocoes";

declare 
%rest:GET 
%rest:path("/clientes")

function page:getClients() {
    
    let $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-ccgmg/endpoint/data/v1/action/find"
    let $api-key := "L07HmkmBFvyN2VdoiLNJ7ic7Iyp59h3nJVSJUKopOlq0dtaytCrUAI5Kyfi6ZCJY"
    
    let $json-data :=
      '{    
          "collection":"Clientes",
          "database":"PhoneForYouDb",
          "dataSource":"TPPEI",
          "filter" : {}
          
      }'
     
     let $mongodb-response := http:send-request(
      <http:request method='post'>    
        <http:header name="api-key" value="{$api-key}"/>
        <http:body media-type='application/json'>{text {$json-data}}</http:body>
      </http:request>,
      $url
    )
           
    for $c in $mongodb-response//json//documents//_
    
    
    return
      element Cliente {
          element q:ID {data($c/client__id)},
          element q:PrimeiroNome {data($c/client/first__name)},
          element q:UltimoNome {data($c/client/last__name)},
          element q:Email {
              let $email := data($c/client/email)
              return
                  if ($email = "") then
                      "desconhecido"
                  else
                      $email
          },
          element q:Morada {
              element q:Pais {data($c/client/address/country/country)},
              element q:Cidade {data($c/client/address/city/city)},
              element q:CodigoPostal {data($c/client/address/postal__code)}
          },
          element q:TipoCliente {"regular"},
          element q:ComprasNosUltimos3Anos {data($c/numero__de__compras)},
          element q:ValorTotalCompras{data($c/valor__total__compras)}
        
      }
        
 
};

declare %rest:GET %rest:path("/produtos") function page:getProdutos() {
    let $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-ccgmg/endpoint/data/v1/action/find"
    let $api-key := "L07HmkmBFvyN2VdoiLNJ7ic7Iyp59h3nJVSJUKopOlq0dtaytCrUAI5Kyfi6ZCJY"
    let $json-data :=
        '{
            "collection":"Produtos",
            "database":"PhoneForYouDb",
            "dataSource":"TPPEI",
            "filter" : {}
        }'
    let $mongodb-response := http:send-request(
        <http:request method='post'>
            <http:header name="api-key" value="{$api-key}"/>
            <http:body media-type='application/json'>{text {$json-data}}</http:body>
        </http:request>,
        $url
    )

    for $p in $mongodb-response//json//documents//_
    where data($p/product__id)
    return
        <Produtos>
            <l:Code>{data($p/product__id)}</l:Code>
            <l:Marca>{data($p/product/brand)}</l:Marca>
            <l:Modelo>{data($p/product/model)}</l:Modelo>
            <l:Preco>{data($p/product/list__price)}</l:Preco>
            {
                for $sub in $p/product/sub__category/name/*
                let $subData := data($sub)
                let $tagName :=
                    if ($subData = 'Budget Smartphones' or $subData = 'Mid-Range Smartphones' or $subData = 'High-End Smartphones')
                        then 'l:GamaDePrecos'
                    else if ($subData = 'Basic Performance' or $subData = 'Standard Performance' or $subData = 'High-Performance' or $subData = 'Gaming')
                        then 'l:Desempenho'
                    else if ($subData = 'Basic Cameras' or $subData = 'Good Cameras' or $subData = 'Pro-Level Cameras')
                        then 'l:QualidadeDaCamaraFrontal'
                    else if ($subData = 'Small (Under 5 inches)' or $subData = 'Medium (5-6.4 inches)' or $subData = 'Large (6.5 inches and above)')
                        then 'l:TamanhoDoEcra'
                    else if ($subData = 'Short Battery Life' or $subData = 'Average Battery Life' or $subData = 'Long Battery Life')
                        then 'l:CapacidadeDaBateria'
                    else if ($subData = 'Low Storage' or $subData = 'Medium Storage' or $subData = 'High Storage')
                        then 'l:CapacidadeDeArmazenamento'
                    else ()
                let $newTagContent :=
                    if ($subData = 'Budget Smartphones')
                        then 'Budget'
                    else if ($subData = 'Mid-Range Smartphones')
                        then 'Mid-Range'
                    else if ($subData = 'High-End Smartphones')
                        then 'High-End'
                    else if ($subData = 'Basic Performance')
                        then 'Basic'
                    else if ($subData = 'Standard Performance')
                        then 'Standard'
                    else if ($subData = 'High-Performance')
                        then 'High'
                    else if ($subData = 'Gaming')
                        then 'Gaming'
                    else if ($subData = 'Basic Cameras')
                        then 'Basic'
                    else if ($subData = 'Good Cameras')
                        then 'Good'
                    else if ($subData = 'Pro-Level Cameras')
                        then 'Pro'
                    else if ($subData = 'Small (Under 5 inches)')
                        then 'Small'
                    else if ($subData = 'Medium (5-6.4 inches)')
                        then 'Medium'
                    else if ($subData = 'Large (6.5 inches and above)')
                        then 'Large'
                    else if ($subData = 'Short Battery Life')
                        then 'Short'
                    else if ($subData = 'Average Battery Life')
                        then 'Average'
                    else if ($subData = 'Long Battery Life')
                        then 'Long'
                    else if ($subData = 'Low Storage')
                        then 'Low'
                    else if ($subData = 'Medium Storage')
                        then 'Medium'
                    else if ($subData = 'High Storage')
                        then 'High'
                    else $subData
                return
                    if ($tagName) then
                        element {$tagName} {$newTagContent}
                    else
                        ()
            }
        </Produtos>
};



declare 
%rest:GET 
%rest:path("/venda")

function page:getVendas() {
    
    let $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-ccgmg/endpoint/data/v1/action/find"
    let $api-key := "L07HmkmBFvyN2VdoiLNJ7ic7Iyp59h3nJVSJUKopOlq0dtaytCrUAI5Kyfi6ZCJY"
    
    let $json-data :=
      '{    
          "collection":"Vendas",
          "database":"PhoneForYouDb",
          "dataSource":"TPPEI",
          "filter" : {}
      }'

     
     let $mongodb-response := http:send-request(
      <http:request method='post'>    
        <http:header name="api-key" value="{$api-key}"/>
        <http:body media-type='application/json'>{text {$json-data}}</http:body>
      </http:request>,
      $url
    )
    
           
    for $c in $mongodb-response//json//documents//_
    where data($c/invoice__id) and data($c/customer__id) and data($c/date) and data($c/total__value)
    return
         <Vendas>
            <i:CodigoFatura>{data($c/invoice__id)}</i:CodigoFatura>
            <i:DataVenda>{data($c/date)}</i:DataVenda>
            <i:CodigoCliente>{data($c/customer__id)}</i:CodigoCliente>
            <i:ValorTotalVenda>{data($c/total__value)}</i:ValorTotalVenda>
            <i:LinhasVenda>
                {
                for $line in $c/sales__lines/*
                return 
                    <i:LinhaVenda>
                        <i:NumeroLinha>{data($line/invoice__id)}</i:NumeroLinha>
                        <i:CodigoProduto>{data($line/product__id)}</i:CodigoProduto>
                        <i:Quantidade>{data($line/quantity)}</i:Quantidade>
                        <i:ValorTotalLinha>{data($line/total__with__vat)}</i:ValorTotalLinha>
                    </i:LinhaVenda>
                }
            </i:LinhasVenda>
        </Vendas>
        
        
};




declare
  %rest:GET
  %rest:path("/relatorioVendas/{$ano}/{$mes}")
function page:getRelatorioVendas($ano as xs:integer, $mes as xs:integer) {
  let $clientes := page:getClients()
  let $vendas := page:getVendas()
  let $produtos := page:getProdutos()
  
  let $anoFiscal := xs:gYear(fn:string($ano))
  let $mesDocumento := xs:gMonth(concat("--", fn:format-number($mes, "00")))

  let $formattedAno := fn:format-number($ano, "0000")
  let $formattedMes := fn:format-number($mes, "00")

  let $vendasNoMes :=
    for $venda in $vendas
    let $vendaAno := fn:format-dateTime(xs:dateTime($venda/i:DataVenda), "[Y0001]")
    let $vendaMes := fn:format-dateTime(xs:dateTime($venda/i:DataVenda), "[M01]")
    where $vendaAno eq $formattedAno and $vendaMes eq $formattedMes
    return $venda

  let $clientesAtivos := 
    for $cliente in $clientes
    where number($cliente/q:ComprasNosUltimos3Anos) > 0
    return $cliente

  let $idsProdutosVendidos := distinct-values(
    for $venda in $vendasNoMes/i:LinhasVenda/i:LinhaVenda
    return $venda/i:CodigoProduto
  )
  
  let $produtosVendidos := 
    for $produto in $produtos
    where $produto/l:Code = $idsProdutosVendidos
    return $produto

  let $numeroDeClientesDiferentes := count($clientesAtivos)
  let $numeroTotalDeVendas := count($vendas)
  let $numeroDeProdutosDiferentes := count($idsProdutosVendidos)
  
  
   let $categorias := ('GamaDePrecos', 'Desempenho', 'QualidadeDaCamaraFrontal', 'TamanhoDoEcra', 'CapacidadeDaBateria', 'CapacidadeDeArmazenamento')
  
  let $vendasPorCategoria :=
    for $categoria in $categorias
    for $valor in distinct-values($produtosVendidos/*[local-name() = $categoria])
    let $numeroVendas := 
      count(
        for $produto in $produtosVendidos
        where $produto/*[local-name() = $categoria] = $valor
        return $produto
      )
    return
      element j:VendasPorCategoria {
        element j:Categoria {$valor},
        element j:NumeroVendas {$numeroVendas}
      }
      
    let $relatorio :=
 element Vendas {

    element InformacaoGeral {
      element k:NIF {"1234567"},
      element k:Nome {"EmpresaDestas"},
      element k:Morada {"RuadAqui"},
      element k:AnoFiscal {$anoFiscal},
      element k:MesDocumento {$mesDocumento}        
    },
    element Cliente {
      $clientesAtivos
    },
    element Produtos {
      $produtosVendidos
    },
    element Venda {
      for $venda in $vendasNoMes
      return $venda
    },
    element ResumoVendas {
      element j:NumeroDeClientesDiferentes {$numeroDeClientesDiferentes},
      element j:NumeroDeProdutosDiferentes {$numeroDeProdutosDiferentes},
      element j:NumeroTotalDeVendas {$numeroTotalDeVendas},
      $vendasPorCategoria
    }
  } 

  return $relatorio
};


declare
  %rest:POST
  %rest:path("/relatorioVendas/{$ano}/{$mes}")
function page:postRelatorioVendas($ano as xs:integer, $mes as xs:integer) {
  let $relatorio := page:getRelatorioVendas($ano, $mes) 

  let $caminhoDoArquivo := "C:\Program Files (x86)\BaseX\webapp\TPPEI\xsd\relatorioVendas.xml"
  let $salvarArquivo := file:write($caminhoDoArquivo, $relatorio)

  return <resultado>
           <mensagem>Relatório de vendas salvo com sucesso em: {$caminhoDoArquivo}</mensagem>
         </resultado>
};

declare 
%rest:GET 
%rest:path("/devolucao")

function page:getDevolucoes() {
    
    let $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-ccgmg/endpoint/data/v1/action/find"
    let $api-key := "L07HmkmBFvyN2VdoiLNJ7ic7Iyp59h3nJVSJUKopOlq0dtaytCrUAI5Kyfi6ZCJY"
    
    let $json-data :=
      '{    
          "collection":"Devoluções",
          "database":"PhoneForYouDb",
          "dataSource":"TPPEI",
          "filter": {}
          
      }'
     
     let $mongodb-response := http:send-request(
      <http:request method='post'>    
        <http:header name="api-key" value="{$api-key}"/>
        <http:body media-type='application/json'>{text {$json-data}}</http:body>
      </http:request>,
      $url
    )
             
    for $c in $mongodb-response//json//documents//_
    where data($c/invoice__id) and data($c/date) and data($c/dias__entre__venda__e__devolucao)
    return
        <Devolucoes>
            <p:IDFatura>{data($c/invoice__id)}</p:IDFatura>
            <p:DataFatura>{data($c/date)}</p:DataFatura>
            <p:DiasDevolucao>{data($c/dias__entre__venda__e__devolucao)}</p:DiasDevolucao>
            {
                if (data($c/dias__entre__venda__e__devolucao) < 3) then
                    <p:DevolucaoPrecoce>true</p:DevolucaoPrecoce>
                else 
                    <p:DevolucaoPrecoce>false</p:DevolucaoPrecoce>
            }
            <p:ListaProdutos>
                {
                for $line in $c/produtos/*
                return 
                <p:Product>
                        <p:ProdutoId>{data($line/product__id)}</p:ProdutoId>
                        
                    </p:Product>
                }
            </p:ListaProdutos>
        </Devolucoes>       
};  


declare
  %rest:GET
  %rest:path("/relatorioDevolucoes/{$ano}/{$mes}")

function page:getRelatorioDevolucoes($ano as xs:integer, $mes as xs:integer) {
  let $produtos := page:getProdutos()
  let $devolucoes := page:getDevolucoes()
  
  let $anoFiscal := xs:gYear(fn:string($ano))
  let $mesDocumento := xs:gMonth(concat("--", fn:format-number($mes, "00")))

  let $formattedAno := fn:format-number($ano, "0000")
  let $formattedMes := fn:format-number($mes, "00")
  
let $devolucoesNoMes :=
    for $devolucao in $devolucoes
    let $devolucaoAno := fn:format-dateTime(xs:dateTime($devolucao/p:DataFatura), "[Y0001]")
    let $devolucaoMes := fn:format-dateTime(xs:dateTime($devolucao/p:DataFatura), "[M01]")
    where $devolucaoAno eq $formattedAno and $devolucaoMes eq $formattedMes
    return $devolucao
    
    let $idsProdutosDevolvidos := distinct-values(
    for $devolucao in $devolucoesNoMes/p:ListaProdutos/p:Product
    return $devolucao/p:ProdutoId
)

let $produtosDevolvidos :=
    for $produto in $produtos
    where $produto/l:Code = $idsProdutosDevolvidos
    return $produto
    
    let $numeroDeProdutosDiferentes := count($idsProdutosDevolvidos)
    
    let $categorias := ('GamaDePrecos', 'Desempenho', 'QualidadeDaCamaraFrontal', 'TamanhoDoEcra', 'CapacidadeDaBateria', 'CapacidadeDeArmazenamento')
    
    
  let $devolucoesPorCategoria :=
    for $categoria in $categorias
    for $valor in distinct-values($produtosDevolvidos/*[local-name() = $categoria])
    let $numeroDevolucoes := 
      count(
        for $produto in $produtosDevolvidos
        where $produto/*[local-name() = $categoria] = $valor
        return $produto
      )
    return
      element o:DevolucoesPorCategoria {
        element o:Categoria {$valor},
        element o:NumeroDevolucoes {$numeroDevolucoes}
      }
  
  let $relatorio :=
  element Devolucoes  { 

    element InformacaoGeral {
        element k:NIF {"1234567"},
        element k:Nome {"EmpresaDestas"},
        element k:Morada {"RuadAqui"},
        element k:AnoFiscal {$anoFiscal},
        element k:MesDocumento {$mesDocumento}        
    },
    element Produtos {
      $produtosDevolvidos
    },
    element Devolucao {
      for $devolucao in $devolucoesNoMes
      return $devolucao
    },
    element ResumoDevolucoes {
      element o:NumeroDeProdutosDiferentes {$numeroDeProdutosDiferentes},
      $devolucoesPorCategoria
    }
  }

  return $relatorio
};
declare
  %rest:POST
  %rest:path("/relatorioDevolucoes/{$ano}/{$mes}")
function page:postRelatorioDevolucoes($ano as xs:integer, $mes as xs:integer) {
  let $relatorio := page:getRelatorioDevolucoes($ano, $mes) 

  let $caminhoDoArquivo := "C:\Program Files (x86)\BaseX\webapp\TPPEI\xsd\relatorioDevolucoes.xml"
  let $salvarArquivo := file:write($caminhoDoArquivo, $relatorio)

  return <resultado>
           <mensagem>Relatório de devolucoes salvo com sucesso em: {$caminhoDoArquivo}</mensagem>
         </resultado>
};
