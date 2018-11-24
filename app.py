from flask import Flask, render_template, request, url_for, redirect
import json, requests
app = Flask(__name__)

class Api:

    def __init__(self):
        self.url_padrao = 'http://localhost:8080/api/v1'
        self.aluno_url =  self.url_padrao + '/alunos/'
        self.disciplina_url  = self.url_padrao + '/disciplinas/'
        self.professor_url  = self.url_padrao + '/professores/'
        self.turma_url = self.url_padrao + '/turmas'

    def cadastro_aluno(self):
        url_param = self.url_padrao + '/alunos/'
        return url_param

    def cadastro_disciplina(self):
        url_param = self.url_padrao + '/disciplinas/incluir/'
        return url_param


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


@app.route("/cadastro-aluno/", methods=['POST'])
def cadastro_usuario():
    print('entrou no cadastro')
    if request.method == "POST":
        nome =  request.form.get("nome")
        email = request.form.get("email")
        senha = request.form.get("senha")
        api = Api()

        dados = {"nome": nome, "email": email, "senha": senha}
        response = requests.post(api.cadastro_aluno(), dados)
        if response.status_code == 200:
            print('status 200 retornado')
            json_response = json.loads(response.content)
            return redirect("/aluno/perfil/{}".format(json_response['response']['id']))
        else:
            return "<h1>Erro ao efetuar cadastro</h1>"

    else:
        return "não deu"


@app.route("/aluno/perfil/<id>", methods=['GET'])
def aluno_perfil(id):
    print("-> entrou na rota perfil")
    api = Api()
    response = requests.get(api.get_aluno_by_id(id))

    if response.status_code == 200:
        print("-> retornou status 200")
        json_response = json.loads(response.content)
        print(json_response)
        id_nome = json_response['response']['id_aluno']
        nome = json_response['response']['nome']
        email = json_response['response']['email']
        print(nome)

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
        print(json_response)
        return render_template('disciplina.html', disciplina=json_response['response'][0])

    else:
        return "<h1>disciplina não encontrada</h1>"

@app.route("/disciplina/cadastrar", methods=['POST','GET'])
def cadastrar_disciplina():
    if request.method == "POST":
        print("funcionando")    
        disciplina =  request.form.get("nome")
        descricao = request.form.get("descricao")                     
        api = Api()
        
        dados = {"disciplina": disciplina, "descricao": descricao}
        response = requests.post(api.cadastro_disciplina(), dados)
        if response.status_code == 200:
            msg = {"texto":"Disciplina Cadastrada com sucesso!","class":"alert alert-success"}
        else:
            msg = {"texto":"Erro ao cadastrar disciplina!","class":"alert alert-danger"}

        return render_template("disciplina_form.html", msg=msg)

    if request.method == "GET":
        return render_template("disciplina_form.html")

@app.route("/turma/cadastrar", methods=['POST','GET'])
def cadastrar_turma():
    api = Api()
    if request.method == "GET":
        
        disciplinas = requests.get(api.disciplina_url)
        json_disciplinas = json.loads(disciplinas.content)

        professores = requests.get(api.professor_url)
        json_professor = json.loads(professores.content)
        return render_template("turma_form.html", disciplinas=json_disciplinas['response'], professores=json_professor['response'])


if __name__ == "__main__":
    app.run(port=3000, debug=True)
