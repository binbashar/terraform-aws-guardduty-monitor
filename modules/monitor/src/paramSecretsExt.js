const http = require('http');

exports.getSecret = async (secret_arn, secret_key) => {
    console.log('Getting webhook URL from Secret Manager');
    
    const options = {
            hostname: 'localhost',
            port: process.env.PARAMETERS_SECRETS_EXTENSION_HTTP_PORT,
            path: '/secretsmanager/get?secretId=' + secret_arn,
            headers: {
                'X-Aws-Parameters-Secrets-Token': process.env.AWS_SESSION_TOKEN
            },
            method: 'GET'
        };
        
    return new Promise((resolve, reject) => {
        const req = http.request(options, res => {
            let data = '';

            res.on('data', d => {
                data += d;
            });

            res.on('end', () => {
                try {
                    const jsonData = JSON.parse(data);
                    const jsonSecrets = JSON.parse(jsonData['SecretString']);
                    resolve(jsonSecrets[secret_key]);
                } catch (error) {
                    reject(error);
                }
            });
        });

        req.on('error', error => {
            reject(error);
        });

        req.end();
    });
};

exports.getParameter = async (parameter_name, parameter_encrypted = true) => {
    console.log('Getting webhook URL from Parameter Store');
    
    const options = {
            hostname: 'localhost',
            port: process.env.PARAMETERS_SECRETS_EXTENSION_HTTP_PORT,
            path: '/systemsmanager/parameters/get/?name=' + encodeURIComponent(parameter_name) + '&withDecryption=' + parameter_encrypted,
            headers: {
                'X-Aws-Parameters-Secrets-Token': process.env.AWS_SESSION_TOKEN
            },
            method: 'GET'
        };
        
    return new Promise((resolve, reject) => {
        const req = http.request(options, res => {
            let data = '';

            res.on('data', d => {
                data += d;
            });

            res.on('end', () => {
                try {
                    const jsonData = JSON.parse(data);
                    resolve(jsonData['Parameter']['Value']);
                } catch (error) {
                    reject(error);
                }
            });
        });

        req.on('error', error => {
            reject(error);
        });

        req.end();
    });
};