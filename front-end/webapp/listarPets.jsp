<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Pets Cadastrados</title>

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    
    <style>
        /* ==========================================================================
           ESTILOS GLOBAIS E LAYOUT PRINCIPAL
           ========================================================================== */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            color: #3a414e;
        }

        .container {
            max-width: 900px;
            width: 90%;
            margin: 40px auto;
            padding: 30px;
            box-sizing: border-box;
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #006d77;
            font-size: clamp(24px, 4vw, 36px);
            border-bottom: 2px solid #83c5be;
            padding-bottom: 10px;
        }
        
        /* ESTILO PARA O CAMPO DE BUSCA */
        .search-container {
            margin-bottom: 30px;
        }
        #buscaPet {
            width: 100%;
            padding: 15px;
            font-size: 1.1em;
            border-radius: 8px;
            border: 1px solid #ddd;
            box-sizing: border-box;
        }
        
        /* ==========================================================
           ESTILO MODERNO PARA OS CARDS DOS PETS
           ========================================================== */
        .pets-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
            margin-top: 20px;
        }
        .pet-card {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            padding: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .pet-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }
        .pet-card-main {
            display: flex;
            align-items: flex-start;
            gap: 20px;
        }
        .pet-photo-card {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #83c5be;
            flex-shrink: 0;
            margin-top: 5px;
        }
        .pet-details { flex-grow: 1; }
        .pet-details h3 {
            margin: 0 0 15px 0;
            color: #006d77;
            font-size: 1.6em;
            font-weight: 600;
        }
        .pet-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
        }
        .pet-info-item {
            display: flex;
            align-items: flex-start;
            font-size: 0.95em;
            color: #555;
            line-height: 1.5;
        }
        .pet-info-item b { color: #333; }
        .pet-info-item svg {
            width: 18px;
            height: 18px;
            margin-right: 10px;
            fill: #83c5be;
            flex-shrink: 0;
            margin-top: 2px;
        }
        
   
      /* ==========================================================================
   ESTILOS PARA O MODAL DE DETALHES (VERSÃO PROFISSIONAL)
   ========================================================================== */

.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.6);
    padding: 20px;
    box-sizing: border-box;
    animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: scale(0.95); }
    to { opacity: 1; transform: scale(1); }
}

.modal.is-visible {
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal-content {
    background-color: #ffffff;
    border-radius: 16px;
    width: 90%;
    max-width: 700px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    position: relative;
    max-height: 90vh;
    overflow: hidden; /* Controla o scroll a partir do modal-body */
    display: flex;
    flex-direction: column;
    padding: 0; /* Removido padding para dar espaço ao header e body */
}

.modal .close {
    color: #fff;
    opacity: 0.8;
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 32px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s;
    text-shadow: 0 1px 3px rgba(0,0,0,0.3);
}

.modal .close:hover { 
    opacity: 1;
    transform: rotate(90deg);
}

.modal-header {
    background-color: #006d77;
    color: #fff;
    padding: 20px 30px;
    display: flex;
    align-items: center;
    gap: 20px;
}

.modal-photo {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid #fff;
    flex-shrink: 0;
}

.modal-header-text h2 {
    margin: 0;
    font-size: 1.8em;
    color: #fff;
    border: none;
    padding: 0;
}

.modal-header-text p {
    margin: 5px 0 0 0;
    opacity: 0.9;
}

.modal-body {
    padding: 25px 30px;
    overflow-y: auto; /* Permite scroll apenas no corpo do modal */
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 15px 25px;
}

.detail-item {
    font-size: 1em;
    line-height: 1.6;
}

.detail-item strong {
    display: block;
    color: #006d77;
    font-weight: 600;
    margin-bottom: 4px;
}

.health-section {
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #eef2f6;
}

.health-section h4 {
    color: #006d77;
    margin-top: 0;
    margin-bottom: 10px;
    font-size: 1.1em;
}

.health-section p {
    background-color: #f7f9fc;
    border-left: 4px solid #83c5be;
    padding: 10px;
    margin: 0 0 10px 0;
    border-radius: 4px;
    font-size: 0.95em;
}


.history-list {
    list-style-type: none;
    padding-left: 0;
    margin-top: 10px;
}

.history-item {
    background-color: #f8f9fa;
    border-radius: 8px;
    padding: 10px 15px;
    margin-bottom: 8px;
    border: 1px solid #e9ecef;
}

.history-item .date {
    font-weight: 600;
    color: #006d77;
}

.history-item .reason {
    font-size: 0.9em;
    color: #555;
    margin-top: 4px;
    display: block;
}
    </style>
</head>
<body>
    
<div class="container">
    <h1>Todos os Pets Cadastrados</h1>
    <div class="search-container">
        <input type="text" id="buscaPet" onkeyup="buscarPets()" placeholder="Buscar por nome do pet, raça, dono ou CPF...">
    </div>
    <div class="pets-grid" id="listaDePets">
        <%-- Os pets serão carregados aqui via AJAX --%>
    </div>
</div>
    
    <script>
    function buscarPets() {
        let termo = document.getElementById('buscaPet').value;
        let xhr = new XMLHttpRequest();
        
        xhr.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                document.getElementById('listaDePets').innerHTML = this.responseText;
            }
        };
        
        xhr.open("POST", "buscarPets.jsp", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.send("termo=" + encodeURIComponent(termo));
    }

    // Carrega a lista completa de pets quando a página é aberta pela primeira vez
    document.addEventListener('DOMContentLoaded', function() {
        buscarPets();
    });

    // Funções para controlar o modal
    function abrirModal(modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('is-visible');
        }
    }

    function fecharModal(modalId) {
        event.stopPropagation(); 
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('is-visible');
        }
    }
</script>
    
</body>
</html>