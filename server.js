// const express = require('express');
// const { exec } = require('child_process');
// const app = express();

// // Endpoint for executing the Bash script
// app.get('/execute-script', (req, res) => {
//     console.log('====================================');
//     console.log('Executing script...');
//     console.log('====================================');
//     exec('./check-execution-time.sh', (error, stdout, stderr) => {
//         if (error) {
//             console.error(`Error executing script: ${error}`);
//             return res.status(500).json({ error: 'Internal Server Error' });
//         }

//         // Parse the JSON response from the Bash script
//         let responseObject;
//         try {
//             responseObject = JSON.parse(stdout);
//         } catch (parseError) {
//             console.error(`Error parsing JSON: ${parseError}`);
//             return res.status(500).json({ error: 'Invalid JSON response' });
//         }

//         // Send the parsed JSON response
//         res.json(responseObject);
//     });
// });

// // Start the server
// const PORT = 3000;
// app.listen(PORT, () => {
//     console.log(`Server is running on port ${PORT}`);
// });
