import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ItemsModule } from './items/items.module';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

@Module({
  imports: [ItemsModule, PrometheusModule.register()],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
