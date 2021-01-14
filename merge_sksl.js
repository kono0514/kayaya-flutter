const fs = require('fs');

const argv = require('minimist')(process.argv.slice(2));

if (argv._.length === 0) {
    throw new Error('Please supply sksl shader filenames');
}

if (!argv.hasOwnProperty('o')) {
    throw new Error('Please specify output file with -o');
}

let output_shader = {
    'platform': '',
    'name': '',
    'engineRevision': '',
    'data': {},
};
for (const f of argv._) {
    const raw = fs.readFileSync(f);
    const shader_json = JSON.parse(raw);

    if (output_shader.platform === '' || output_shader.engineRevision === '') {
        output_shader.engineRevision = shader_json['engineRevision'];
        output_shader.platform = shader_json['platform'];
        output_shader.name = shader_json['name'];
    } else {
        if (output_shader.engineRevision !== shader_json['engineRevision']) {
            throw new Error('Engine revision doesn\'t match.');
        }
        if (output_shader.platform !== shader_json['platform']) {
            throw new Error('Platform doesn\'t match');
        }
    }

    for (const shader_key in shader_json['data']) {
        if (output_shader.data.hasOwnProperty(shader_key)) continue;
        output_shader.data[shader_key] = shader_json['data'][shader_key];
    }
}
fs.writeFileSync(argv.o, JSON.stringify(output_shader), {flag: 'wx'});
console.log(`Wrote merged shaders to ${argv.o}`);
