## 4.1 Configuration Decoupling


The key principle is decoupling application code from site-specific configuration. The application image should be generic, while deployment specifics are externalized.

Configuration decoupling ensures that application settings (`ConfigMaps`), sensitive data (`Secrets`), and API access credentials (`ServiceAccounts`) are managed externally to the Pod definition. This promotes portability and security.


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
