/* eslint-disable @typescript-eslint/camelcase */
export type ModelStructure = {
  layer: object;
  connection: object;
}

export interface IFinetuneConfigObject {
  model: string;
  data_module: object;
  min_epochs: number;
  max_epochs: number;
  optimizer_type: string;
  optimizer_property: object;
  lr_scheduler_type: string;
  lr_scheduler_property: object;
  loss_function: string;
}

export type FinetuneConfig = 
  | Partial<IFinetuneConfigObject>
  | IFinetuneConfigObject;

export const DEFAULT_FINETUNE_CONFIG: FinetuneConfig = {
  model: '',
  data_module: {dataset_name: 'CIFAR10', batch_size: 4},
  min_epochs: 10,
  max_epochs: 15,
  optimizer_type: 'Adam',
  optimizer_property: {
    betas: [0.9, 0.99],
    eps: 1e-08,
    weight_decay: 0,
    amsgrad: false
  },
  lr_scheduler_type: 'StepLR',
  lr_scheduler_property: {lr: 0.01, step_size: 30},
  loss_function: 'torch.nn.CrossEntropyLoss'
}


export const DEFAULT_CONFIG_SCHEMA = {
  'type': 'object',
  'properties': {
    'dataset': {
      'key': 'dataset',
      'type': 'string',
      'title': 'dataset',
      'name': 'Select Dataset',
      'x-component': 'select',
      'enum': [
        {
          'label': 'CIFAR10',
          'value': 'CIFAR10'
        },
        {
          'label': 'MNIST',
          'value': 'MNIST'
        },
        {
          'label': 'ImageNet',
          'value': 'ImageNet'
        },
        {
          'label': 'Customized',
          'value': 'Customized'
        }
      ],
      'default': 'CIFAR10'
    },
    'upload': {
      'key': 'upload',
      'type': 'array',
      'title': 'Upload Dataset',
      'name': 'upload',
      'text': 'Click or drag file to this area to upload',
      'x-component-props': {
        'listType': 'dragger',
        'locale': true,
        'locale.uploadText': 'test'
      },
      'x-component': 'upload'
    }
  }
}