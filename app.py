from flask import Flask, render_template, request, url_for, redirect
import json, requests
app = Flask(__name__)

@app.route("/")
@app.route("/index")
def home():
	return render_template("index.html")


@app.route("/cadastro-aluno/", methods=['GET', 'POST'])
def cadastro_usuario():
    if request.method == "POST":
        print("funcionando")    
        nome = request.form.get("nome")
        email = request.form.get("email")
        senha = request.form.get("senha")

        dados = {"nome":nome, "email":email, "senha": senha}
        response = requests.post("http://localhost:8080/api/v1/alunos/", dados)

        if response.status_code == 200:
            print("status true 200")
            return "<h1>Cadastro realizado com sucesso</h1>"
        else:
            return "<h1>Erro ao efetuar cadastro</h1>"
        
    else:
        return "não deu"


@app.route("/aluno/login", methods=['GET', 'POST'])
def aluno_login():
    email = request.form.get("email")
    senha = request.form.get("senha")

    dados = {"email":email, "senha": senha}
    response = requests.post("http://localhost:8080/api/v1/alunos/login/", dados)

    if response.status_code == 200:
        return "<h1>Usuario encontrado"

    else:
        return "<h1>Usuario não encontrado"


if __name__ == "__main__":
    app.run(port=3000, debug=True)