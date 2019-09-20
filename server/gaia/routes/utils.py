from functools import wraps

from firebase_admin.auth import verify_id_token, CertificateFetchError, \
    RevokedIdTokenError, ExpiredIdTokenError, InvalidIdTokenError
from flask import request
from schema import SchemaError

from gaia.models.db import User
from gaia.utils.exceptions import BadRequest, Unauthorized


def verify_user() -> User:
    token = request.args.get('token')

    if token is None:
        return User[1]
        # raise BadRequest('Missing token')

    try:
        data = verify_id_token(token, check_revoked=False)
    except (
            InvalidIdTokenError,
            ExpiredIdTokenError,
            RevokedIdTokenError,
            CertificateFetchError,
    ) as e:
        print(e)
        raise Unauthorized()

    uid = data['uid']

    user = User.get(uid=uid)

    if user is not None:
        return user

    return User(uid=uid)


def auth_required(decorated):
    @wraps(decorated)
    def decorator(*args, **kwargs):
        user = verify_user()
        return decorated(*args, **kwargs, user=user)

    return decorator


def validate_with(schema, data):
    try:
        return schema.validate(data)
    except SchemaError as e:
        print(e)
        raise BadRequest()
