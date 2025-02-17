import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { envs } from './config';
import { Logger, ValidationPipe } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';

async function bootstrap() {
  const logger = new Logger('Main Orders');

  const app = await NestFactory.createMicroservice<MicroserviceOptions>(
    AppModule,
    {
      transport: Transport.TCP,
      options: {
        host: '0.0.0.0',
        port: envs.port,
      },
      logger: ['log', 'debug', 'warn', 'error'],
    },
  );

  // app.useGlobalPipes(new ValidationPipe());
  // app.useLogger(new Logger());

  await app.listen();
  logger.log(`Trabajando en el puerto: ${envs.port}`);
}
bootstrap();
