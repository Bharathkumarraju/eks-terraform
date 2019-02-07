from invoke import Collection
from . import kubernetes

ns = Collection()

ns.add_collection(kubernetes, 'kubernetes')
