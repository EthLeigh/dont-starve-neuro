import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';

export default tseslint.config(
  { ignores: ['dist', '**/*.d.ts'] },
  {
    files: ['**/*.ts'],
    languageOptions: {
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
        project: './tsconfig.json',
      },
    },
    extends: [js.configs.recommended, ...tseslint.configs.recommended, prettier],
    // TODO: Make these rules not so strict and let TypeScript infer what it can
    rules: {
      '@typescript-eslint/consistent-type-imports': 'error',
      '@typescript-eslint/no-explicit-any': ['error', { ignoreRestArgs: false }],
      '@typescript-eslint/explicit-function-return-type': [
        'warn',
        { allowExpressions: true, allowHigherOrderFunctions: true },
      ],
      '@typescript-eslint/explicit-module-boundary-types': 'warn',
      '@typescript-eslint/consistent-type-definitions': ['error', 'type'],
      'no-console': 'off',
      quotes: ['error', 'single', { avoidEscape: true, allowTemplateLiterals: true }],
    },
  },
);
