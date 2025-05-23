from flask import Flask
from auth.routes import auth_bp
from main.routes import main_bp
from flask_session import Session


def create_app():
    flask_app = Flask(__name__)
    flask_app.secret_key = 'super-secret-key'
    flask_app.config['SESSION_TYPE'] = 'filesystem'
    Session(flask_app)

    flask_app.register_blueprint(auth_bp)
    flask_app.register_blueprint(main_bp)

    return flask_app


if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
