const url = require('url');
const https = require('https');

const paramExt = require('paramSecretsExt');

const post = async (uri, body) => {
    body = JSON.stringify(body);

    const options = url.parse(uri);

    options.method = 'POST';

    options.headers = {
        'Content-Type': 'application/json',
        'Content-Length': body.length
    };

    return new Promise((resolve, reject) => {
        const req = https.request(options, (res) => {
            if (res.statusCode === 200) {
                res.on('end', () => {
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
};

exports.handler = async (event) => {
    console.log(event);
    
    let slack_webhook = '';
    
    if (process.env.PARAMETER_NAME) {
        slack_webhook = await paramExt.getParameter(process.env.PARAMETER_NAME, process.env.PARAMETER_ENCRYPTED);
    }
    
    if (process.env.SECRET_ARN) {
        slack_webhook = await paramExt.getSecret(process.env.SECRET_ARN, process.env.SECRET_KEY);
    }
    
    const { detail={} } = event;
    const { title='', description='', accountId='', region='' } = detail;

    if (!title && !description) {
        return;
    }

    if (slack_webhook) {
        console.log('Sending slack notification');

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
            await post(slack_webhook, slackMessage);
        } catch (e) {
            console.error(e);
        }

        console.log('Slack notification sent');
    }
};
