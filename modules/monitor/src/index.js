const url = require('url');
const https = require('https');

const { SecretsManagerClient, GetSecretValueCommand } = require("@aws-sdk/client-secrets-manager");

const secretsManager = new SecretsManagerClient();

async function getSecret(secretName) {

    try {
        const command = new GetSecretValueCommand({ SecretId: secretName });
        const data = await secretsManager.send(command);
        return data.SecretString;
    } catch (err) {
        console.error("Error retrieving secret:", err);
        throw err;
    }
}

const post = async (uri, body) => {
    body = JSON.stringify(body);

    const options = url.parse(uri);

    options.method = 'POST'

    options.headers = {
        'Content-Type': 'application/json',
        'Content-Length': body.length
    }

    return new Promise((resolve, reject) => {
        const req = https.request(options, (res) => {
            if (res.statusCode === 200) {
                res.once('end', () => {
                    resolve();
                });
            } else {
                reject(new Error(`Unexpected status code: ${res.statusCode}`));
            }
        });

        req.on('error', (error) => {
            reject(error);
        });

        req.end(body);
    });
}

exports.handler = async (event) => {
    console.log(event)

    const { detail={} } = event
    const { title='', description='', accountId='', region='' } = detail

    if (!title && !description) {
        return
    }
    
    let slackWebhook = ""

    try {
        slackWebhook = await getSecret(process.env.SLACK_NOTIFICATION_URL);
    } catch (error) {
        console.error('Error retrieving secret:', error);
    }

    if (process.env.SLACK_NOTIFICATION_URL) {
        console.log('Sending slack notification')

        const slackMessage = {
            text:     `*${title ? title : '-'}*`,
            username: 'aws-organization',
            attachments: [
                {
                    color: 'danger',
                    fallback: `${description ? description : '-'}`,
                    fields: [
                        {
                            title: "Account ID",
                            value: `${accountId ? accountId : '-'}`,
                            short: true
                        },
                        {
                            title: "Region",
                            value: `${region ? region : '-'}`,
                            short: true
                        },
                        {
                            title: "Description",
                            value: `${description ? description : '-'}`,
                            short: false
                        }
                    ]
                }
            ]
        };

        try {
            await post(slackWebhook, slackMessage)
        } catch (e) {
            console.error(e)
        }

        console.log('Slack notification sent')
    }
}