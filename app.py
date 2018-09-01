from flask import Flask, render_template, request, url_for, redirect
import json, requests
app = Flask(__name__)

class Api:
    aluno_url = 'http://localhost:8080/api/v1/alunos/'
    disciplina_url = 'http://localhost:8080/api/v1/disciplinas/'

    def get_aluno_by_id(self, id):
        url_param = self.aluno_url+"{}"
        return url_param.format(id)

    def get_disciplina_by_id(self, id):
        url_param = self.disciplina_url+"{}"
        return url_param.format(id)


class Aluno:
    def __init__(self,id, nome, email):
	    self.id=id
	    self.nome=nome
	    self.email=email

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

        api = Api()
        dados = {"nome":nome, "email":email, "senha": senha}
        response = requests.post(api.aluno_url, dados)
        if response.ok:
            json_response = json.loads(response.content)
            
            return redirect("/aluno/perfil/{}".format(json_response['response']['insertId']))
        else:
            return "<h1>Erro ao efetuar cadastro</h1>"
        
    else:
        return "não deu"


@app.route("/aluno/perfil/<id>", methods=['GET'])
def aluno_perfil(id):
    api = Api()
    response = requests.get(api.get_aluno_by_id(id))
    
    if response.status_code == 200:
        json_response = json.loads(response.content)
        id_nome = json_response['response'][0]['id_aluno']
        nome = json_response['response'][0]['nome']
        email = json_response['response'][0]['email']
        
        aluno = Aluno(id_nome,nome,email)
        response_disciplinas = requests.get(api.disciplina_url)
        json_disciplinas = json.loads(response_disciplinas.content)

        return render_template('perfil.html',aluno=aluno, disciplinas=json_disciplinas['response'])

    else:
        return "<h1>perfil não encontrado</h1>"

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


@app.route("/disciplina/", methods=['GET'])
def disciplina():
    api = Api()
    disciplina = request.args["id"]
    response = requests.get(api.get_disciplina_by_id(disciplina))
    
    if response.ok:
        json_response = json.loads(response.content)

        return render_template('disciplina.html', disciplina=json_response['response'][0])

    else:
        return "<h1>disciplina não encontrada</h1>"

if __name__ == "__main__":
    app.run(port=3000, debug=True)