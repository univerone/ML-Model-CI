# test ModelCI CLI with unitest
from pathlib import Path

import requests
import torch
import tempfile
from typer.testing import CliRunner
import torchvision
from modelci.config import app_settings
from modelci.cli.modelhub import app

runner = CliRunner()
file_dir = str(Path.home() / '.modelci/ResNet50/pytorh-pytorch/image_classification')
Path(file_dir).mkdir(parents=True, exist_ok=True)
weight_path = f'{tempfile.gettempdir()}/1.pth'
model_path = f'{file_dir}/1.pth'


def test_get():
    result = runner.invoke(app, [
        'get',
        'https://download.pytorch.org/models/resnet50-19c8e357.pth',
        weight_path
    ])
    assert result.exit_code == 0
    assert "model downloaded successfully" in result.stdout


def test_publish():
    torch_model = torchvision.models.resnet50(pretrained=False)
    torch_model.load_state_dict(torch.load(weight_path))
    torch.save(torch_model, model_path)
    result = runner.invoke(app, [
        'publish', '-f', 'example/resnet50.yml'
    ])
    assert result.exit_code == 0
    assert "\'status\': True" in result.stdout


def test_ls():
    result = runner.invoke(app, ['ls'])
    assert result.exit_code == 0


def test_detail():
    with requests.get(f'{app_settings.api_v1_prefix}/model/') as r:
        model_list = r.json()
    model_id = model_list[0]["id"]
    result = runner.invoke(app, ['detail', model_id])
    assert result.exit_code == 0


def test_update():
    with requests.get(f'{app_settings.api_v1_prefix}/model/') as r:
        model_list = r.json()
    model_id = model_list[0]["id"]
    result = runner.invoke(app, ['update', model_id, '--framework', 'TensorFlow'])
    assert result.exit_code == 0


def test_convert():
    result = runner.invoke(app, [
        'convert', '-f', 'example/resnet50.yml'
    ])
    assert result.exit_code == 0


def test_delete():
    with requests.get(f'{app_settings.api_v1_prefix}/model/') as r:
        model_list = r.json()
    for model in model_list:
        model_id = model["id"]
        result = runner.invoke(app, ['delete', model_id])
        assert result.exit_code == 0
        assert f"Model {model_id} deleted\n" == result.output
