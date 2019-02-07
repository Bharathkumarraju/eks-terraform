from invoke import task
import re
import json

@task
def create(ctx, cluster):
    ctx.run('eksctl create cluster --name {}'.format(cluster))


@task
def delete(ctx, cluster):
    ctx.run('eksctl delete cluster {}'.format(cluster))


@task
def stacks(ctx, cluster, output):
    stacks = ctx.run('eksctl utils describe-stacks --name {0} | grep NodeInstanceRole'.format(cluster), hide='out')
    cluster = ctx.run('eksctl get cluster -o json', hide='out')
    cluster_info = json.loads(cluster.stdout)

    role_arn = re.findall(r'OutputValue: "(.*)"', stacks.stdout)[0]
    role_name = re.findall(r'/(.*)', role_arn)[0]
    tfvars = {
        "region": cluster_info[0]['region'],
        "add_kube2iam": True,
        "eks_worker_iam_role_arn": ("{}".format(role_arn)),
        "eks_worker_iam_role_name": ("{}".format(role_name))
    }
    with open(output, 'w') as f:
        f.write(json.dumps(tfvars, indent=4))
